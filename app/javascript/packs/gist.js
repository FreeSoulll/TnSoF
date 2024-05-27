const gistClient = require("gist-client")
const gistClientInstance = new gistClient()
const githubToken = process.env.GIST_KEY;
gistClientInstance.setToken(githubToken);


const links = document.querySelectorAll('.link');

links.forEach((item) => {
  if (!item.classList.contains('loaded')) {
    const gistItem = item.querySelector('.gist');
    if (gistItem) {
      const gistId = gistItem.dataset.gist_id;
      const content = gistItem.querySelector('.content');
      const description = gistItem.querySelector('.description');
      const author = gistItem.querySelector('.author');
      gistClientInstance.getOneById(gistId)
        .then(response => {
          content.textContent = Object.values(response.files)[0].content;
          description.textContent = response.description;
          author.textContent = response.owner.login;
          item.classList.add('loaded');
        }).catch(err => {
          console.error(err);
        });
    }
  }
});

