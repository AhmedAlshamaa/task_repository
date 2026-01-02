شرح مختصر عن تكامل التطبيق مع DummyJSON (API فقط)

- Base URL: `https://dummyjson.com` (`lib/helpera/constants.dart`).
- الموارد: `todos`.

- Endpoints:
  - GET `/todos`
  - POST `/todos/add` (body: `todo`, `completed`, `userId`, `description`)
  - PUT `/todos/{id}` (body: `todo`, `completed`, `description`)
  - DELETE `/todos/{id}`

- ملاحظة مهمة: DummyJSON قد يعيد `id` عند POST لكن لا يضمن بقاء العنصر قابلاً للتعديل/الحذف لاحقاً — لذلك PUT/DELETE قد ترجع 404.

- سلوك التطبيق عند 404: يتم تطبيق التغيير محلياً في `Hive` كـfallback ويعرض تحذيراً.

- أمثلة سريعة (PowerShell):
  - GET: `Invoke-RestMethod -Method Get -Uri 'https://dummyjson.com/todos'`
  - POST: `Invoke-RestMethod -Method Post -Uri 'https://dummyjson.com/todos/add' -Body ('{"todo":"X","completed":false,"userId":1}')`

- إذا تريّد CRUD ثابتة: استخدم `json-server` محليًا وغيّر `apiBaseUrl` إلى `http://localhost:3000`.

