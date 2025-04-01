window.addEventListener("DOMContentLoaded", () => {
  const input = document.getElementById("search");
  const results = document.getElementById("search-results");

  fetch("/index.json")
    .then((res) => res.json())
    .then((pages) => {
      const idx = lunr(function () {
        this.ref("link");
        this.field("title");
        this.field("content");

        pages.forEach((page) => this.add(page));
      });

      input.addEventListener("input", () => {
        const query = input.value.trim();
        const matches = idx.search(query);
        results.innerHTML = matches.map(({ ref }) => {
          const page = pages.find(p => p.link === ref);
          return `<li><a href="${page.link}">${page.title}</a></li>`;
        }).join("");
      });
    });
});