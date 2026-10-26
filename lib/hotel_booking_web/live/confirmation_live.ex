defmodule HotelBookingWeb.ConfirmationLive do
  use HotelBookingWeb, :live_view

  def mount(_params, _session, socket) do
    booking = %{
      guest: "Zee",
      host: "Ngumbao",
      room: "Tsavo",
      ref: "MS-2026 0421-AH",
      check_in: %{date: "26 Oct", note: "Monday · 15:00"},
      check_out: %{date: "29 Oct", note: "Thursday · 10:00"},
      lines: [
        {"Room . Tsavo × 4 nights", "€ 620.00"},
        {"Breakfast × 2 guests", "€ 96.00"},
        {"Tourist tax", "€ 14.40"}
      ],
      total: "€ 730.40",
      network: "Muhembo",
      password: "Muhembo@123"
    }

    nav = [
      %{label: "Your stay", icon: "hero-calendar-days", badge: "1", current: true},
      %{label: "The house", icon: "hero-home"},
      %{label: "Around town", icon: "hero-map-pin"},
      %{label: "Breakfast", icon: "hero-bell-alert"},
      %{label: "Messages", icon: "hero-envelope"}
    ]

    {:ok,
     assign(socket,
       booking: booking,
       nav: nav,
       menu_open?: false,
       page_title: "Booking confirmed"
     )}
  end

  def handle_event("toggle-menu", _params, socket) do
    {:noreply, update(socket, :menu_open?, &(!&1))}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-neutral-100 text-neutral-900 lg:flex">
      <aside
        id="sidebar"
        class={[
          "group flex flex-col border-b border-neutral-400 bg-neutral-50 px-4 pt-3",
          @menu_open? && "fixed inset-0 z-50 overflow-y-auto",
          "lg:sticky lg:top-0 lg:h-screen lg:w-[260px] lg:shrink-0 lg:border-r lg:border-b-0 lg:py-4"
        ]}
      >
        <div class="flex items-center justify-between border-b border-neutral-400 pb-3 lg:pb-4">
          <a href="/" class="flex items-center gap-2">
            <.icon name="hero-sun" class="size-8 text-sun-500" />
            <span class="font-serif text-xl leading-none">
              <span class="block text-terracotta-600 italic">Maison</span>
              <span class="block font-semibold">Soleil</span>
            </span>
          </a>

          <button
            id="menu-btn"
            type="button"
            class="rounded-lg p-2 text-neutral-700 transition hover:bg-neutral-200 lg:hidden"
            aria-controls="sidebar-panel"
            aria-expanded={to_string(@menu_open?)}
            aria-label={if(@menu_open?, do: "Close navigation menu", else: "Open navigation menu")}
            phx-click="toggle-menu"
          >
            <.icon name={if(@menu_open?, do: "hero-x-mark", else: "hero-bars-3")} class="size-5" />
          </button>
        </div>

        <nav
          id="sidebar-panel"
          class={["mt-4", !@menu_open? && "hidden", "lg:block"]}
          aria-label="Main"
        >
          <ul class="space-y-1">
            <li :for={item <- @nav}>
              <a
                href="#"
                aria-current={item[:current] && "page"}
                class={[
                  "flex items-center gap-3 rounded-lg px-3 py-2.5 text-neutral-700 hover:bg-neutral-0",
                  item[:current] && "bg-neutral-0 text-neutral-900 shadow-sm"
                ]}
              >
                <.icon name={item.icon} class="size-5" />
                <span class="flex-1">{item.label}</span>
                <span
                  :if={item[:badge]}
                  class="grid size-5 place-items-center rounded-full bg-terracotta-600 text-[10px] text-neutral-0"
                >
                  {item.badge}
                </span>
              </a>
            </li>
          </ul>
        </nav>

        <div class={["mt-auto pt-10", !@menu_open? && "hidden", "lg:block"]}>
          <div class="relative overflow-hidden rounded-xl bg-sun-300 p-4 show-md">
            <span class="absolute -top-6 -right-6 size-20 rounded-full bg-sun-500/80"></span>
            <p class="relative font-mono text-[10px] tracking-widest uppercase">Today in Cassis</p>
            <p class="relative font-serif text-3xl">27°</p>
            <p class="relative text-xs">Sunny · light breeze</p>
          </div>
          <div class="mt-4 space-y-2 border-t border-dashed border-neutral-400 py-4 font-mono text-[10px] tracking-widest text-neutral-600 uppercase">
            <p>Est. 1987</p>
            <p>Maison Soleil · 12 Rue des Oliviers · Cassis</p>
            <p>© 2026 Maison Soleil</p>
          </div>
        </div>
      </aside>

      <main class="min-w-0 flex-1 px-4 py-6 lg:px-10 lg:py-8">
        <header
          id="confirmation-header"
          class="flex flex-col gap-5 lg:flex-row lg:items-center lg:justify-between"
        >
          <div>
            <p
              id="confirmation-status"
              class="font-mono text-xs tracking-widest text-neutral-600 uppercase"
            >
              Booking · Confirmed
            </p>
            <h1 class="mt-2 font-serif text-4xl lg:text-5xl">
              Bienvenue, <em class="text-terracotta-600">{@booking.guest}.</em>
            </h1>
          </div>

          <div id="confirmation-actions" class="flex w-full gap-3 lg:w-auto">
            <button
              id="print-receipt"
              type="button"
              phx-click={JS.dispatch("hotel:print")}
              class="flex-1 rounded-full border border-neutral-400 px-5 py-3 text-sm font-medium transition hover:bg-neutral-200 lg:flex-none"
            >
              Print receipt
            </button>
            <button
              id="add-to-calendar"
              type="button"
              class="flex-1 rounded-full bg-neutral-900 px-5 py-3 text-sm font-medium text-white transition hover:bg-neutral-700 lg:flex-none"
            >
              Add to calendar
            </button>
          </div>
        </header>

        <section id="booking-summary" class="mt-12 lg:mt-16" aria-label="Booking summary">
          <div
            id="booking-cards"
            tabindex="0"
            class="group relative mx-auto flex max-w-[820px] flex-col-reverse items-center rounded-3xl focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-terracotta-600 lg:flex-row lg:justify-center"
          >
            <article
              id="receipt-card"
              class="relative z-0 -mt-8 w-full max-w-[340px] -rotate-1 rounded-2xl bg-neutral-50 p-5 shadow-xl transition-transform duration-500 ease-out motion-reduce:transition-none lg:mt-0 lg:max-w-[380px] lg:-rotate-[5deg] lg:group-hover:-translate-x-14 lg:group-hover:-rotate-[7deg] lg:group-focus:-translate-x-14 lg:group-focus:-rotate-[7deg]"
            >
              <div class="flex items-start justify-between">
                <div>
                  <p class="font-mono text-[10px] tracking-widest text-neutral-600 uppercase">
                    Receipt
                  </p>
                  <h2 class="font-serif text-xl">Your stay</h2>
                </div>
                <p class="text-right font-mono text-[10px] tracking-wider text-neutral-600">
                  № {@booking.ref}
                </p>
              </div>

              <div class="mt-4 grid grid-cols-2 gap-4 border-t border-dashed border-neutral-400 pt-4 text-center">
                <div>
                  <p class="font-mono text-[10px] tracking-widest text-neutral-600 uppercase">
                    Check in
                  </p>
                  <p class="font-serif text-3xl">{@booking.check_in.date}</p>
                  <p class="text-xs text-neutral-600">{@booking.check_in.note}</p>
                </div>
                <div>
                  <p class="font-mono text-[10px] tracking-widest text-neutral-600 uppercase">
                    Check out
                  </p>
                  <p class="font-serif text-3xl">{@booking.check_out.date}</p>
                  <p class="text-xs text-neutral-600">{@booking.check_out.note}</p>
                </div>
              </div>

              <ul class="mt-4 space-y-2 border-t border-dashed border-neutral-400 pt-4 text-sm">
                <li :for={{name, price} <- @booking.lines} class="flex justify-between gap-3">
                  <span>{name}</span>
                  <span class="font-mono text-xs">{price}</span>
                </li>
              </ul>

              <div class="mt-4 flex items-end justify-between border-t border-neutral-700 pt-3">
                <span class="font-mono text-xs tracking-widest text-neutral-600 uppercase">
                  Total paid
                </span>
                <span class="font-serif text-3xl">{@booking.total}</span>
              </div>

              <div class="mt-4 flex items-end justify-between">
                <span class="font-mono text-[10px] tracking-widest text-neutral-600 uppercase">
                  Paid · Wise · GBP
                </span>
                <span
                  aria-hidden="true"
                  class="h-9 w-24"
                  style="background: repeating-linear-gradient(90deg,#222 0 2px,transparent 2px 4px,#222 4px 5px,transparent 5px 8px,#222 8px 11px,transparent 11px 13px)"
                ></span>
              </div>
            </article>

            <article
              id="welcome-card"
              class="relative z-10 w-full max-w-[340px] rotate-[1.5deg] rounded-3xl bg-gradient-to-br from-terracotta-400 via-terracotta-600 to-terracotta-700 p-6 text-neutral-100 shadow-2xl transition-transform duration-500 ease-out motion-reduce:transition-none lg:-ml-10 lg:max-w-[420px] lg:rotate-3 lg:p-8 lg:group-hover:translate-x-14 lg:group-hover:rotate-[6deg] lg:group-focus:translate-x-14 lg:group-focus:rotate-[6deg]"
            >
              <div class="flex items-start justify-between border-t border-dashed border-neutral-100/40 pt-3">
                <p class="font-mono text-[10px] tracking-widest uppercase">Welcome card</p>
                <.icon name="hero-sun" class="size-9 text-sun-300" />
              </div>
              <p class="mt-10 font-serif text-lg text-sun-300 italic">A note from your host,</p>
              <p class="font-serif text-5xl italic">{@booking.host}.</p>
              <p class="mt-6 text-sm leading-relaxed">
                We're so glad you're coming. The shutters will be open, the lemonade cold, and the
                cat – Poivre – pretending not to notice you.
              </p>
              <p class="mt-10 font-mono text-[10px] tracking-widest uppercase">Room</p>
              <p class="font-serif text-xl">{@booking.room}</p>
            </article>
          </div>

          <p class="mt-6 hidden text-center font-mono text-[10px] tracking-widest text-terracotta-600 uppercase lg:block">
            ✦ Hover or focus to fan ✦
          </p>
        </section>

        <section id="stay-details" class="mt-10 grid gap-5 lg:grid-cols-3" aria-label="Stay details">
          <.detail_card
            id="arrival-card"
            icon="hero-key"
            tone="terracotta"
            label="Arrival"
            num="01"
            title="Check-in from 15:00"
            sub="Mon, 26 October"
          >
            Ring the brass bell by the blue door. If we're at the market, the key is in the
            terracotta pot by the olive tree.
          </.detail_card>

          <.detail_card
            id="wifi-card"
            icon="hero-wifi"
            tone="blue"
            label="Wifi"
            num="02"
            title={@booking.network}
            sub="Password below"
          >
            <dl class="space-y-1.5">
              <div class="flex items-center justify-between rounded-md bg-neutral-200 px-3 py-2">
                <dt class="font-mono text-[10px] tracking-widest text-neutral-600 uppercase">
                  Network
                </dt>
                <dd class="text-xs">{@booking.network}</dd>
              </div>
              <div class="flex items-center justify-between rounded-md bg-neutral-200 px-3 py-1.5">
                <dt class="font-mono text-[10px] tracking-widest text-neutral-600 uppercase">
                  Password
                </dt>
                <dd class="flex items-center gap-2 font-mono text-xs">
                  {@booking.password}
                  <button
                    id="copy-wifi"
                    type="button"
                    phx-hook="CopyText"
                    data-text={@booking.password}
                    class="rounded-full border border-neutral-400 px-2 py-0.5 text-[10px] tracking-widest text-neutral-600 uppercase transition hover:bg-neutral-400"
                  >
                    Copy
                  </button>
                </dd>
              </div>
            </dl>
          </.detail_card>

          <.detail_card
            id="breakfast-card"
            icon="hero-bell-alert"
            tone="rose"
            label="Breakfast"
            num="03"
            title="Served 8 – 10:30"
            sub="On the terrace"
          >
            Fresh figs, Marseille honey, pain au levain, and espresso. Gluten-free option? Leave a
            note the night before.
          </.detail_card>
        </section>
      </main>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :icon, :string, required: true
  attr :tone, :string, required: true
  attr :label, :string, required: true
  attr :num, :string, required: true
  attr :title, :string, required: true
  attr :sub, :string, required: true
  slot :inner_block, required: true

  defp detail_card(assigns) do
    ~H"""
    <article id={@id} class="rounded-2xl border border-neutral-400/60 bg-neutral-50 p-5 shadow-sm">
      <div class={["flex items-center justify-between", tone_text(@tone)]}>
        <div class="flex items-center gap-3">
          <span class={["grid size-10 place-items-center rounded-lg text-neutral-0", tone_bg(@tone)]}>
            <.icon name={@icon} class="size-5" />
          </span>
          <span class="font-mono text-xs tracking-widest uppercase">{@label}</span>
        </div>
        <span class="font-serif text-2xl">{@num}</span>
      </div>
      <h2 class="mt-6 font-serif text-2xl text-neutral-900">{@title}</h2>
      <p class="mt-1 text-xs text-neutral-600">{@sub}</p>
      <div class="mt-4 leading-relaxed text-neutral-700">{render_slot(@inner_block)}</div>
    </article>
    """
  end

  defp tone_text("terracotta"), do: "text-terracotta-600"
  defp tone_text("blue"), do: "text-blue-500"
  defp tone_text("rose"), do: "text-rose-500"

  defp tone_bg("terracotta"), do: "bg-terracotta-600"
  defp tone_bg("blue"), do: "bg-blue-500"
  defp tone_bg("rose"), do: "bg-rose-500"
end
