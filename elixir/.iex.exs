elixir_icon = ""

IEx.configure [
  colors: [
    pretty: true,
    syntax_colors: [
      atom: :light_cyan,
      string: :light_green,
      number: :light_blue,
      nil: :light_magenta,
      list: :light_white,
      tuple: :light_white,
      map: :light_white,
      keyword_list: :light_white,
      keyword: :default_color,
      boolean: :light_magenta,
      binary: :light_yellow,
      hash_set: :light_white,
      hash_dict: :light_white,
      regex: :light_red,
      struct: :light_white
    ],
    eval_result: [:cyan, :bright] ,
    eval_error: [[:red, :bright, "\n✘ \n"]],
    eval_info: [:yellow, :bright ],
  ],
  inspect: [
    limit: :infinity,
    charlists: :as_lists,
    pretty: true,
    binaries: :as_strings,
    printable_limit: :infinity
  ],
  default_prompt: [
    "\e[G", # cursor ⇒ column 1
    :light_cyan,
    "%prefix",
    :light_magenta,
    # custome elixir symbol; I used "". You can update at the beginnning of
    # this config
    " ", elixir_icon, " ",
    :yellow, "|",
    :light_magenta,
    "%counter",
    :yellow, "▶",
    :reset
  ] |> IO.ANSI.format |> IO.chardata_to_string
  ]

#  Application.load(:tzdata)
#  :ok = Application.ensure_started(:tzdata)

# Import ecto quries for testing quries in iex
# import_if_available(Ecto.Query)

