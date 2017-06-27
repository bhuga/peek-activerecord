$(document).on('click', '#js-peek-activerecord-toggle', function(e) {
  table = document.getElementById('peek-activerecord-modal');
  peek = document.getElementById('peek')
  peek.appendChild(table);
  peek.classList.toggle('display-activerecord-modal')
  e.preventDefault();
  return false;
});
