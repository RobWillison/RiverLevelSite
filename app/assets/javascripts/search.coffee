
$(window).load ->
  $('#search').select2({
    width: '100%',
    height: '100%',
    theme: "bootstrap",
    ajax: {
      url: "/api/rivers/search",
      type: 'GET',
      processResults: (data) -> return { results: data }
    }
  }
  )

  $('#search').on("change", (e) ->
    location.href = '/rivers/' + $('#search').val()
  )
