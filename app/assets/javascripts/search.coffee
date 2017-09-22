
$(window).load ->
  $('#search').select2({
    theme: "bootstrap",
    ajax: {
      url: "/echo/json/",
      type: 'GET',
      processResults: (data) -> return data
    }
  }
  )
