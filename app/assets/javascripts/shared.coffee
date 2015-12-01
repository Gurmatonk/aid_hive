$(document).ready ->
  $('a').filter ->
    this.href.match /commontator\/threads\/\d+/
  .click()
