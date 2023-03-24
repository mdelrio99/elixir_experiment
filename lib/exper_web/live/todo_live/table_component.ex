defmodule ExperWeb.TodoLive.TableComponent do
  use ExperWeb, :live_component
  require Logger
#  use ExperWeb.CoreComponents

#  alias Phoenix.LiveView.JS

#  alias Exper.Library

  @impl true
  def mount(socket) do
    {:ok, assign(socket, :data, [])}
  end

  @impl true
  def render(assigns) do
    Logger.info("WOW")
#    Logger.info(assigns)
#    IO.puts(assigns)

  ~H"""
    <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0" style="padding-right:5px">
    <table class="w-[40rem] sm:w-full" >
          <thead class="text-left text-[0.8125rem] leading-6 text-zinc-500" style="display:">
            <tr>
              <th :for={col <- @col} class="p-0 pb-4 pr-6 font-normal"><%= col[:label] %></th>
              <th class="relative p-0 pb-4"><span class="sr-only"><%= gettext("Actions") %></span></th>
            </tr>
          </thead>
          <tbody
            id={@id}
            phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
            class="relative divide-y divide-zinc-100  border-zinc-200 text-sm leading-6 text-white"
            >
          </tbody>
        </table>
      </div>
"""


    # assigns =
    #   with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
    #     assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
    #   end

    #   ~H"""
    #   <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0" style="padding-right:5px">
    #   <table class="w-[40rem] sm:w-full" >
    #     <thead class="text-left text-[0.8125rem] leading-6 text-zinc-500" style="display:">
    #       <tr>
    #         <th :for={col <- @col} class="p-0 pb-4 pr-6 font-normal"><%= col[:label] %></th>
    #         <th class="relative p-0 pb-4"><span class="sr-only"><%= gettext("Actions") %></span></th>
    #       </tr>
    #     </thead>
    #     <tbody
    #       id={@id}
    #       phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
    #       class="relative divide-y divide-zinc-100  border-zinc-200 text-sm leading-6 text-white"
    #       >
    #       <tr :for={row <- @rows} id={@row_id && @row_id.(row)} class="group hover:bg-slate-500 border-b">
    #         <td
    #           :for={{col, i} <- Enum.with_index(@col)}
    #           phx-click={@row_click && @row_click.(row)}
    #           class={["relative p-0", @row_click && "hover:cursor-pointer"]}
    #         >
    #           <div class="block py-4 pr-6">
    #             <span class="absolute -inset-y-px right-0 -left-2 group-hover:bg-slate-500 sm:rounded-l-xl" />
    #             <span class={["relative", i == 0 && "font-semibold text-white"]}
    #             >
    #               <%= render_slot(col, @row_item.(row)) %>
    #             </span>
    #           </div>
    #         </td>
    #         <td :if={@action != []} class="relative p-0 w-14">
    #           <div class="relative whitespace-nowrap py-10 text-right text-sm font-medium">
    #             <span class="absolute -inset-y-px -right-3 left-0 group-hover:bg-slate-500 sm:rounded-r-xl" />
    #             <span
    #               :for={action <- @action}
    #               class="relative ml-4 font-semibold leading-6 text-white hover:text-zinc-700"
    #             >
    #               <%= render_slot(action, @row_item.(row)) %>
    #             </span>
    #           </div>
    #         </td>
    #       </tr>
    #     </tbody>
    #   </table>
    # </div>
    # """
  end

end
