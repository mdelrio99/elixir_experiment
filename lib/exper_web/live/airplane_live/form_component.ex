defmodule ExperWeb.AirplaneLive.FormComponent do
  use ExperWeb, :live_component

  alias Exper.Library

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage airplane records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="airplane-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
      <.input field={@form[:model]} type="text" label="Model" />
      <.input field={@form[:year]} type="text" label="Year" />
      <.input field={@form[:url]} type="text" label="URL" />
      <.input field={@form[:price]} type="text" label="Price" />
      <:actions>
          <.button phx-disable-with="Saving...">Save Airplane</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{airplane: airplane} = assigns, socket) do
    changeset = Library.change_airplane(airplane)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"airplane" => airplane_params}, socket) do
    changeset =
      socket.assigns.airplane
      |> Library.change_airplane(airplane_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"airplane" => airplane_params}, socket) do
    save_airplane(socket, socket.assigns.action, airplane_params)
  end

  defp save_airplane(socket, :edit, airplane_params) do
    case Library.update_airplane(socket.assigns.airplane, airplane_params) do
      {:ok, airplane} ->
        notify_parent({:saved, airplane})

        {:noreply,
         socket
         |> put_flash(:info, "Airplane updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_airplane(socket, :new, airplane_params) do
    case Library.create_airplane(airplane_params) do
      {:ok, airplane} ->
        notify_parent({:saved, airplane})

        {:noreply,
         socket
         |> put_flash(:info, "Airplane created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
