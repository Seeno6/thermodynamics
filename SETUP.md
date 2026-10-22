# Heat Hero Trainer: setup (about 20 minutes)

The `site` folder is the whole website: `index.html`, `config.js`, and the `songs` folder.

## 1. Database (Supabase, free)
1. Go to supabase.com, sign up, and create a new project. Pick any name and password.
2. Open **SQL Editor > New query**, paste all of `supabase_setup.sql`, and press **Run**.
3. Open **Authentication > Providers > Email** and turn **Confirm email OFF**.
4. Open **Project Settings > API**. Copy the **Project URL** and the **anon public** key into `config.js`.

## 2. Accounts
Open **Authentication > Users > Add user > Create new user**. Tick **Auto Confirm User**.
- **Each student:** email = `nickname@thermo.class` (all lowercase, no spaces), password = the one you give them. The student signs in with just the nickname and that password.
- **You (coach):** use your real email and a password you choose.
- Then open SQL Editor and run, with your own email:
  `insert into public.coaches (user_id) select id from auth.users where email = 'YOUR_COACH_EMAIL';`

## 3. Publish (GitHub Pages)
1. Create a free GitHub repository (public).
2. Upload the contents of the `site` folder to it (`index.html`, `config.js`, `songs/`, and the `.sql` and `.md` files).
3. Settings > Pages > Source: **Deploy from a branch**, branch **main**, folder **/ (root)**. Save.
4. Your link will be `https://YOURNAME.github.io/REPONAME/`. Send that to students.

## What people see
- **Students:** sign in with nickname and password and see Division B and Division C only. Progress saves automatically and follows them to any device.
- **You:** sign in as coach to also see **Teach: B vs C**, including the **Students (progress)** table.
- **Not signed in:** Division B and C only. Progress stays on that device and you cannot see it.

## Good to know
- The Teach tab is hidden from the screen for students. It is not locked: a student who knows how to read a web page's source could find its text. The Teach tab holds teaching tips, not student data or passwords.
- Student data is protected by the database rules: a student can only read and write their own progress.
- Use nicknames, not real names.
