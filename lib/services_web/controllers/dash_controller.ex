defmodule ServicesWeb.DashController do
  use ServicesWeb, :controller
  alias Services.Servicing

  def dash(conn, _params) do

    users = [
      %{
        id: 1,
        name: "Bikram",
        bio: "I am Bikram, ipsum dolor sit amet consectetur adipisicing elit. Qui, repellat?",
        profile_picture: "https://img.freepik.com/free-vector/bearded-man-cartoon-vector-illustration_1308-175444.jpg",
        cover_photo: "https://img.freepik.com/free-vector/background_53876-57973.jpg",
        service: "Fashion designer",
        custom_price: 100000,
        description: "Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quos minima vel autem porro aliquam quaerat!"
        },

      %{
        id: 2,
        name: "Dawa",
        bio: "I am Dawa, ipsum dolor sit amet consectetur adipisicing elit. Qui, repellat?",
        profile_picture: "https://img.freepik.com/free-vector/cheerful-cartoon-boy-face_1308-162460.jpg",
        cover_photo: "https://img.freepik.com/free-vector/modern-flowing-wave-banner-background_1035-18591.jpg",
        service: "Adventure tour guide",
        custom_price: 95000,
        description: "Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quos minima vel autem porro aliquam quaerat!"
        },

      %{
        id: 3,
        name: "Kundan",
        bio: "I am Kundan, ipsum dolor sit amet consectetur adipisicing elit. Qui, repellat?",
        profile_picture: "https://img.freepik.com/free-photo/happy-cartoon-boy-with-big-eyes_1308-171308.jpg",
        cover_photo: "https://img.freepik.com/free-photo/abstract-design-background_1048-9262.jpg",
        service: "Accountant",
        custom_price: 999999,
        description: "Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quos minima vel autem porro aliquam quaerat!"
        },

      %{
        id: 4,
        name: "Phuntsho",
        bio: "I am Phuntsho, ipsum dolor sit amet consectetur adipisicing elit. Qui, repellat?",
        profile_picture: "https://img.freepik.com/free-photo/happy-woman-with-short-hair_1308-171290.jpg",
        cover_photo: "https://img.freepik.com/free-photo/orange-bokeh-lights-background_53876-98264.jpg",
        service: "Entrepreneur",
        custom_price: 10101010,
        description: "Lorem ipsum dolor sit amet consectetur, adipisicing elit. Quos minima vel autem porro aliquam quaerat!"
      }
    ]

    is_hidden = Servicing.is_hidden(conn.assigns.current_scope)

    categories = Servicing.list_categories()

    render(conn, :dash, is_hidden: is_hidden, users: users, categories: categories)
  end
end
