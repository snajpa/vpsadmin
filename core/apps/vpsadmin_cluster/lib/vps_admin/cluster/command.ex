defmodule VpsAdmin.Cluster.Command do
  alias VpsAdmin.Cluster
  alias VpsAdmin.Cluster.Schema
  alias VpsAdmin.Cluster.Query

  @callback create(ctx :: map, args :: any) :: map

  defmacro __using__([]) do
    quote do
      @behaviour unquote(__MODULE__)
      import unquote(__MODULE__)
      alias VpsAdmin.Cluster
    end
  end

  def new(ctx) do
    %Schema.Command{
      transaction_id: ctx.transaction.id,
      transaction_confirmations: [],
    }
  end

  def create(ctx, cmd_mod, opts \\ [], fun \\ nil) do
    cmd = ctx
      |> new()
      |> Map.put(:module, to_string(cmd_mod))

    ctx
    |> Cluster.Transaction.Context.command(cmd)
    |> cmd_mod.create(opts)
    |> confirmations(fun)
  end

  def finalize(ctx) do
    ctx = update_in(ctx.command.transaction_confirmations, &Enum.reverse/1)
    Query.Command.create(ctx.command)
    ctx
  end

  defp confirmations(ctx, nil), do: ctx
  defp confirmations(ctx, fun), do: fun.(ctx)
end