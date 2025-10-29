# Weekly Summary
[[<% tp.date.now("gggg-[W]ww", -1, tp.file.title, "gggg-[W]ww") %>]] <== This Week ==> [[<% tp.date.now("gggg-[W]ww", +7, tp.file.title, "gggg-[W]ww") %>]] 

## Completed Tasks
```dataview
TASK 
FROM "0. Periodic Notes/Daily Notes" 
WHERE completed AND dateformat(date(file.name), "yyyy-'W'WW") = this.file.name
```

---
## Notes

```dataviewjs
// Define the header to search for and the expected file name format
const headerToSearch = "Notes";
const currentFileName = dv.current().file.name;

const specificDirectory = "0. Periodic Notes/Daily Notes"; 

// Recursively render nested lists
function renderListRecursive(items, level) {
  if (!items || items.length === 0) return;
  const rendered = items.map(item => {
	  let indent = "  ".repeat(level);
    if (item.children && item.children.length > 0) {
      return [`${indent}${level > 0 ? "-" : ""} ${item.text}`, renderListRecursive(item.children, level + 1)].join("\n");
    } else {
	    return `${indent}${level > 0 ? "-" : ""} ${item.text}`;
    }
  })
  
  if (level > 0) {
	  return rendered.join("\n");
  } else {
	  return rendered;
  }
}

// 1. Get all pages in the vault.
const allPages = dv.pages(`"${specificDirectory}"`);

// 2. Filter pages that match the date condition and contain the specified header.
const filteredPages = allPages
  .where(p => {
    // Check if the file name contains a valid date in the format 'YYYY-WXX'
    // and if the date matches the current file's name.
    const fileDate = dv.date(p.file.name);
    return fileDate && fileDate.toFormat("yyyy-'W'WW") === currentFileName;
  })
  .where(p => p.file.lists.some(l => l.section && l.section.subpath === headerToSearch));

// 3. Group the filtered pages by the specified date format.
const groupedPages = filteredPages.groupBy(p => {
  const fileDate = dv.date(p.file.name);
  // Safely return the formatted date string, handle potential errors.
  return fileDate ? fileDate.toFormat("yyyy, MMMM dd") : "Invalid Date";
});

// 4. Render the grouped lists.
for (let group of groupedPages) {
  for (let page of group.rows) {
    // Find the root list items for the current page and section.
    const rootLists = page.file.lists
      .where(l => l.section && l.section.subpath === headerToSearch)
      .where(l => !l.parent);
    dv.header(4, page.file.link)

    const markdown = renderListRecursive(rootLists, 0);
    dv.paragraph(markdown)
  }
}
```
---

## Retrospective
> Note down any milestones, learnings, and things to work on / improve going forward



