/* global SimpleMDE */

const articleId = window.articleId;

const simplemde = new SimpleMDE({
  element: document.getElementById('js-md-body'),
  autosave: {
    enabled: articleId !== 'new',
    uniqueId: articleId,
    delay: 1000
  },
  placeholder: 'Something interesting...',
  status: ['autosave', 'lines', 'words', 'cursor'],
  renderingConfig: {
    singleLineBreaks: false,
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
    .replace(/[^a-zA-Z\-]/g, '');

const autoGenerateSlug = () => {
  slugInput.value = titleToSlug(titleInput.value);
};

titleInput.addEventListener('keyup', e => {
  if (dirtySlug) return;

  autoGenerateSlug();
});

slugInput.addEventListener('change', () => {
  dirtySlug = true;
  if (slugInput.value === '') {
    dirtySlug = false;
    autoGenerateSlug();
  }
});
