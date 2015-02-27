$ ->
  $(".sortable").sortable(
      axis: "x",
      cancel: ".unsortable",
      items: "li:not(.unsortable)",
      cursor: "move",
      opacity: 0.5,
      scroll: true,
      tolerance: "pointer",
      update: (event, ui)->
        group_id = ui.item.attr("data-group-id")
        for i in [0..$(ui.item).parent().children().length]
          if $(ui.item).parent().children().eq(i).attr("data-group-id") == group_id
            $.ajax(
              type: "PATCH",
              url: "/groups/#{group_id}/change_order",
              data:{ order: i }
            )
    )