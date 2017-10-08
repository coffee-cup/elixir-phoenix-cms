export default function() {
  function buildHiddenInput(name, value) {
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = name;
    input.value = value;
    return input;
  }

  function handleLinkClick(link) {
    const message = link.getAttribute('data-confirm');
    // eslint-disable-next-line
    if (message && !window.confirm(message)) {
      return;
    }

    const to = link.getAttribute('data-to');
    const method = buildHiddenInput(
      '_method',
      link.getAttribute('data-method')
    );
    const csrf = buildHiddenInput(
      '_csrf_token',
      link.getAttribute('data-csrf')
    );
    const form = document.createElement('form');

    form.method = link.getAttribute('data-method') === 'get' ? 'get' : 'post';
    form.action = to;
    form.style.display = 'hidden';

    form.appendChild(csrf);
    form.appendChild(method);
    document.body.appendChild(form);
    form.submit();
  }

  window.addEventListener(
    'click',
    function(e) {
      let element = e.target;

      while (element && element.getAttribute) {
        if (element.getAttribute('data-method')) {
          handleLinkClick(element);
          e.preventDefault();
          return false;
        }
        element = element.parentNode;
      }
    },
    false
  );
}
