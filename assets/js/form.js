/* global SimpleMDE */

const articleId = window.articleId;

// eslint-disable-next-line
const simplemde = new SimpleMDE({
  element: document.getElementById('js-md-body'),
  autosave: {
    enabled: articleId !== 'new',
    uniqueId: articleId,
    delay: 1000
  },
  placeholder: 'Something interesting...',
  status: ['autosave', 'lines', 'words', 'cursor'],
  indentWithTabs: false,
  renderingConfig: {
    singleLineBreaks: true,
    codeSyntaxHighlighting: true
  }
});

let dirtySlug = false;

const titleInput = document.querySelector('.js-input-title');
const slugInput = document.querySelector('.js-input-slug');

const titleToSlug = title =>
  title
    .toLowerCase()
    .split(' ')
    .join('-')
    .replace(/[^a-zA-Z0-9\-]/g, '');

const autoGenerateSlug = () => {
  slugInput.value = titleToSlug(titleInput.value);
};

titleInput.addEventListener('keyup', () => {
  if (dirtySlug) {
    return;
  }

  autoGenerateSlug();
});

slugInput.addEventListener('change', () => {
  dirtySlug = true;
  if (slugInput.value === '') {
    dirtySlug = false;
    autoGenerateSlug();
  }
});
