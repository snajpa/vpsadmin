require 'libosctl'
require 'mysql2'

module NodeCtld
  class Db
    include OsCtl::Lib::Utils::Log

    def initialize(db = nil)
      db ||= $CFG.get(:db)

      connect(db)
    end

    def query(q)
      protect do
        Result.new(@my.query(q))
      end
    end

    def prepared(q, *params)
      protect do
        st = @my.prepare(q)
        Result.new(st.execute(*params))
      end
    end

    def insert_id
      @my.last_id
    end

    def transaction(kwargs = {})
      restart = kwargs.has_key?(:restart) ? kwargs[:restart] : true
      wait = kwargs[:wait]
      tries = kwargs[:tries]
      counter = 0
      try_restart = true

      begin
        log(:info, :sql, "Retrying transaction, attempt ##{counter}") if counter > 0
        @my.query('BEGIN')
        yield(DbTransaction.new(@my))
        @my.query('COMMIT')

      rescue RequestRollback
        log(:info, :sql, 'Rollback requested')
        query('ROLLBACK')

      rescue Mysql2::Error => err
        query('ROLLBACK')

        case err.errno
        when 1213
          log(:warn, :sql, 'Deadlock found')

        when 2006
          log(:warn, :sql, 'Lost connection to MySQL server during query')

        when 2013
          log(:warn, :sql, 'MySQL server has gone away')

        else
          try_restart = false
        end

        if restart && try_restart
          counter += 1

          if tries.nil? || tries == 0 || counter <= tries
            w = wait || (counter * 5 + rand(15))
            w = 10 * 60 if w > 10 * 60
            log(:warn, :sql, "Restarting transaction in #{w} seconds")
            sleep(w)
            retry

          else
            log(:critical, :sql, 'All attempts to restart the transaction failed')
          end
        end

        log(:critical, :sql, 'MySQL transactions failed due to database error, rolling back')
        p err.inspect
        p err.traceback if err.respond_to?(:traceback)
        raise err

      rescue => err
        log(:critical, :sql, 'MySQL transactions failed, rolling back')
        p err.inspect
        p err.traceback if err.respond_to?(:traceback)
        query('ROLLBACK')
        raise err
      end
    end

    def union
      u = Union.new(self)
      yield(u)
      u
    end

    def close
      @my.close
    end

    private
    def connect(db)
      if !db[:host].nil? && db[:hosts].empty?
        db[:hosts] << db[:host]
      end

      problem = false

      loop do
        db[:hosts].each do |host|
          begin
            log(:info, :sql, "Trying to connect to #{host}") if problem
            @my = Mysql2::Client.new(
              host: host,
              username: db[:user],
              password: db[:pass],
              database: db[:name],
              encoding: 'utf8',
              connect_timeout: db[:connect_timeout],
              read_timeout: db[:read_timeout],
              write_timeout: db[:write_timeout],
            )
            query('SET NAMES UTF8')
            log(:info, :sql, "Connected to #{host}") if problem
            return

          rescue Mysql2::Error => err
            problem = true
            log(:warn, :sql, "MySQL error ##{err.errno}: #{err.error}")
            log(:info, :sql, 'Trying another host')
          end

          interval = $CFG.get(:db, :retry_interval)
          log(:warn, :sql, "All hosts failed, next try in #{interval} seconds")
          sleep(interval)
        end
      end
    end

    def protect(try_again = true)
      begin
        yield

      rescue Mysql2::Error => err
        log(:critical, :sql, "MySQL error ##{err.errno}: #{err.error}")
        close if @my
        sleep($CFG.get(:db, :retry_interval))
        connect($CFG.get(:db))
        retry if try_again

      rescue Errno::EBADF
        log(:critical, :sql, 'Errno::EBADF raised, reconnecting')
        close if @my
        sleep(1)
        connect($CFG.get(:db))
        retry if try_again
      end
    end
  end

  class DbTransaction < Db
    def initialize(my)
      @my = my
    end

    def protect(try_again = true)
      begin
        yield
      rescue Mysql2::Error => err
        log(:critical, :sql, "MySQL error ##{err.errno}: #{err.error}")
        raise err
      end
    end

    def rollback
      raise RequestRollback
    end
  end

  class Union
    def initialize(db)
      @db = db
      @results = []
    end

    def query(*args)
      @results << @db.query(*args)
    end

    def each
      @results.each do |r|
        r.each do |row|
          yield(row)
        end
      end
    end
  end

  class Result
    # @param result [Mysql2::Result]
    def initialize(result)
      @result = result
    end

    def each(&block)
      @result.each(&block)
    end

    def get
      @result.each { |row| return row }
      nil
    end

    def get!
      get || (fail 'no row returned')
    end

    def count
      @result.count
    end
  end

  class RequestRollback < StandardError ; end
end
