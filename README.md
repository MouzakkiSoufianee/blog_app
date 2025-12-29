# Ticket Blog

Modern Rails blog demo with Turbo/Stimulus drawer flows, inline notices, and themed confirmation modals.

## Screenshots (flow order)
- Index baseline with hero, filters, and inline delete notice: [docs/screenshots/index-with-inline-notice.jpeg](docs/screenshots/index-with-inline-notice.jpeg)
- Post show in drawer with comments and actions: [docs/screenshots/post-view-drawer.jpeg](docs/screenshots/post-view-drawer.jpeg)
- Post edit in drawer: [docs/screenshots/post-edit-drawer.png](docs/screenshots/post-edit-drawer.png)
- Comment edit inline in drawer: [docs/screenshots/comments-edit-delete.jpeg](docs/screenshots/comments-edit-delete.jpeg)
- Custom delete confirm modal (variant 1): [docs/screenshots/delete-confirm-modal-1.jpeg](docs/screenshots/delete-confirm-modal-1.jpeg)
- Custom delete confirm modal (variant 2): [docs/screenshots/delete-confirm-modal-2.jpeg](docs/screenshots/delete-confirm-modal-2.jpeg)
- Filters with search applied and inline notice visible: [docs/screenshots/filters-and-search.jpeg](docs/screenshots/filters-and-search.jpeg)

## Quick start
1) Install deps: `bundle install`
2) Setup DB: `bin/rails db:setup`
3) Run dev server: `bin/rails server`

## Notes
- Turbo + Stimulus power the drawer and form interactions.