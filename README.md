# 💸 Smart Expenses Tracker – Flutter-Based App (AI + Offline + Group Features)

A cross-platform expense tracking app with offline-first support, group-based budget planning, and premium AI budget optimizer.

---

## 📱 App Access Types

### 👤 Guest User (No Login)
- Can access all basic **expense tracking and budget planning** features
- Data stored **locally** using Isar
- Cannot sync across devices
- Cannot use **Group** or **AI** features

### 🔐 Logged-in User (Firebase Auth)
- Access data across devices via **Firestore sync**
- Can **create or join up to 5 groups** (Basic Plan)
- Access all free features + group dashboard
- Upgrade to Premium to unlock AI & unlimited groups

---

## 🆓 Free Features

### 1. **User Authentication**
- Email/password login via Firebase Auth
- Guest users can skip login, but data stays local

### 2. **Expense Tracking**
- Add/Edit/Delete expenses
- Fields: Amount, Date, Category, Note
- Category color and icon support

### 3. **Monthly Budget Planning**
- Set and manage monthly budgets
- View progress with budget vs. expenses
- Pie/Bar charts (via `fl_chart`)

### 4. **Group Budget Sharing (Basic)**
- Only available to **logged-in users**
- Users can:
  - Create a group (gets a `groupId`)
  - Join a group using `groupId`
  - View budgets of group members (read-only)
- Limit: **5 groups per user (basic plan)**
- Data synced via Firestore

### 5. **Offline-first Support**
- All users (guest or logged-in) store data locally in **Isar**
- Logged-in users sync with **Firestore** when online
- Use `updatedAt` and `isSynced` flags for smart sync

---

## 💎 Premium Features (In-App Purchase)

### 1. **AI Budget Optimizer**
- Suggest better budget splits based on past expenses
- Estimate monthly savings potential
- Powered via **OpenAI** or **Gemini** (API)

### 2. **Unlimited Groups**
- Remove 5-group limit for logged-in users
- Allow creating/joining unlimited groups

### 3. **PDF/Excel Report Export** (Optional Phase 2)

### 4. **Premium Screen Access**
- AI Planner screen
- Premium Badge or Tag on unlocked features

---

## 🧱 Tech Stack

| Layer             | Tool/Tech                              |
|------------------|----------------------------------------|
| UI Framework      | Flutter                                |
| Auth              | Firebase Auth                          |
| Local Storage     | Isar (offline-first DB)                |
| Cloud Sync        | Firebase Firestore                     |
| State Management  | Riverpod (or Provider)                 |
| AI Logic          | OpenAI or Gemini API                   |
| In-App Purchases  | `in_app_purchase` Flutter SDK          |
| Charts            | `fl_chart`                             |
| Notifications     | `flutter_local_notifications` (optional) |

---

## 🖥 Screens

- Splash / Onboarding
- Guest/Welcome Screen
- Login / Register
- Home Dashboard
- Add/Edit Expense
- Budget Overview + Charts
- Group Dashboard (Logged-in only)
- AI Budget Planner (Premium only)
- Premium Upgrade Screen
- Profile / Settings

---

## 🧠 Notes & Logic Rules

- Guest users store data locally only (Isar DB)
- Logged-in users get cloud sync and group access
- Group feature is **view-only**, no live editing
- Use `groupId` to fetch member budgets from Firestore
- `isPremium` flag is used to unlock:
  - AI Budget Planner
  - Unlimited groups
  - Export (future)