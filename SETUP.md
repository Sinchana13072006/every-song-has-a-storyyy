# Every Song Has a Story ❤️ — setup guide

This is a responsive, editable romantic playlist website. The visitor link is public; the editing panel requires a Supabase email/password account. The five starter cards are sample copy that you can replace.

## 1. Create the online database
1. Create a free project at https://supabase.com/ and wait for it to finish provisioning.
2. Open **SQL Editor → New query**, paste all of `schema.sql`, and click **Run**.
3. In **Authentication → Providers → Email**, keep Email enabled. In **Authentication → Settings**, turn **off public sign-ups** so strangers cannot create accounts.
4. In **Authentication → Users**, choose **Add user** and create your private admin email/password. Confirm the user if the dashboard offers that option.
5. Open **Project Settings → API**. Copy the Project URL and the `anon` / publishable key.
6. Paste them into `config.js`, replacing `https://YOUR-PROJECT.supabase.co` and `YOUR_SUPABASE_ANON_KEY`. Never put a `service_role` key in this website.

## 2. Run the website
The site is plain HTML/CSS/JavaScript and can be hosted on any static host (Netlify, Vercel static site, or GitHub Pages). For local testing, open a terminal in this folder and run:

```bash
python -m http.server 8000
```

Then open http://localhost:8000. (Use a local web server rather than opening the HTML as a `file://` URL.)

## 3. Personalise and publish
1. Open your deployed website with `?admin=1` added to the URL (for example, `https://your-site.example/?admin=1`). The Admin link is hidden from the normal recipient view.
2. Sign in with the admin email/password created in Supabase.
3. Edit each thought, title, artist, album, link, and story. Upload a JPG, PNG, or WebP photo (up to 8 MB).
4. Use **Add a song**, the ↑ / ↓ controls, or **Delete** to manage the playlist.
5. Tap **Save draft** to save privately, or **Publish playlist** to update the public visitor version.
6. Deploy the whole folder to a static host. Use the normal deployed URL for him; keep the `?admin=1` URL for your own editing. Visitors do not need an account.

## How the data is stored
- Draft text and song/photo URLs are stored in the private `playlist_drafts` table.
- Published song data is stored separately in `playlist_public`, which visitors can read.
- Uploaded photos are stored in the public-read `song-photos` Supabase Storage bucket; only authenticated users can upload or delete.
- The browser only contains the Supabase project URL and anon key. Row-level security policies protect draft rows and writes.

## Important security note
This starter assumes the Supabase project has exactly one trusted admin account. Keep public sign-ups disabled and do not share the admin password. For a multi-admin or higher-security production deployment, replace the broad `authenticated` write policies with a dedicated admin-role check. The site has not been deployed or connected to a Supabase project yet; online persistence and cross-device sharing become active only after you complete the steps above.

## Troubleshooting
- **“Invalid login credentials”**: check the admin email/password in Supabase Authentication → Users.
- **Playlist shows sample songs**: verify `config.js`, SQL setup, and that the `playlist_public` table has a published row. Sample cards are shown until a published playlist exists.
- **Photo upload fails**: check that `schema.sql` ran successfully and that you are signed in.
- **Changes are not public**: use **Publish playlist**, not only **Save draft**.
