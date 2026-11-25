<!-- coderabbit-ai-generated:v1 -->

# Najar Glass House Industries

A public product catalog and private admin panel for Najar Glass House Industries. Customers browse and contact the shop directly; the site does not accept orders or payments.

## Run locally

<!-- coderabbit-ai-generated:v1 -->

<!-- coderabbit-ai-generated-section:v1:9026393e9b43fe066c29ec9db881f6f0d4be5f129c8f36bfe0c41a1d435fa5b0 -->

<!-- coderabbit-ai-generated:v1 -->

<!-- coderabbit-ai-generated-section:v1:0e6809c708eee29feadc5466779b455993e4e9f0463563fa88b16a784239aba3 -->

Open this folder in VS Code. Install Node.js 24.22.0 or newer, open the VS Code terminal, and run `npm install` followed by `npm run dev`. Open http://localhost:3000 in a browser. The `.env` file contains the public URL and publishable key for the existing Supabase project; the browser uses these values to read the catalog. The example pictures illustrate the layout and should be replaced with the shopkeeper's product images. Google sign-in still requires the configuration below.

<!-- /coderabbit-ai-generated:v1 -->

<!-- /coderabbit-ai-generated:v1 -->

## Connect the catalog and admin

<!-- coderabbit-ai-generated:v1 -->

<!-- coderabbit-ai-generated-section:v1:ba7519b7c4077ef6b580e3cf2744ea31a69b3d87a3a8cc2bca52ed809f4fd1bf -->

1. The existing Supabase project has been created and `supabase/schema.sql` run once. The script creates the categories, sample products, image bucket, row-level permissions, and a 1,000-product cap. Removing a category also deletes its products. For a new project, run the script **once**, and back up any existing data before database changes.
2. `.env` contains the existing project URL and publishable key. These are public values protected by database policies; never put a secret or service-role key in the website. To connect a different project, set `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` to its URL and publishable key, then restart the server. Local overrides can be placed in `.env.local`.

<!-- /coderabbit-ai-generated:v1 -->
3. Configure Google as a sign-in provider in Supabase Authentication. Create Google OAuth credentials in Google Cloud using Supabase's callback URL as the Google authorized redirect URI. Add the Google client ID and secret in Supabase, not in the website code. Configure the OAuth consent screen and add the shopkeeper as a test user while the app is in testing mode.
4. In Supabase Authentication URL configuration, set the site URL to `https://najarglasshouse.com` for production, and allow `https://najarglasshouse.com/auth/callback`. For local testing, also allow `http://localhost:3000/auth/callback`. In Google Cloud, add the Supabase callback URL exactly as shown in the Supabase Google provider setup. Follow the provider dashboards for their current configuration requirements.
5. Visit `/admin`, sign in with `maqboolmuzzamil265@gmail.com` or `xamoxm366@gmail.com`, and add or remove products. The database and image policies allow changes only for these Google accounts. Other accounts can browse public products but cannot edit them. Change both the admin email list in `app/admin/page.js` and all policies in `supabase/schema.sql` if the authorized accounts ever change; apply policy changes in Supabase as well.
<!-- coderabbit-ai-generated:v1 -->

<!-- coderabbit-ai-generated-section:v1:1471e336995d132374e51d674ca4c5f57dc50f2208c099b401ac070eecd6ea9c -->

6. Connect the GitHub repository to Cloudflare Workers Builds. Select the branch containing this project, use `npm run build:vinext` for the build command and `npm run deploy:vinext -- --skip-build` for the deploy command. The `.nvmrc` file selects Node 24.22.0 for the build. Cloudflare's Workers free plan has usage limits; check current pricing and limits before launching. For each Cloudflare website URL, allow its exact `/auth/callback` URL in Supabase Authentication URL Configuration. Add its origin to Google OAuth settings where required, and verify Google sign-in and product management. When the purchased custom domain is connected, set the Supabase site URL and allow its callback URL.

<!-- /coderabbit-ai-generated:v1 -->
7. The site includes metadata, a sitemap and robots rules. Once the domain is live, verify it in Google Search Console and submit `https://najarglasshouse.com/sitemap.xml`. Google controls indexing; inclusion is not guaranteed.

Supabase's free tier has storage and traffic limits and may pause inactive projects. Provider terms and plans can change. Check current quotas and hosting terms before launch, and monitor usage. This project does not collect card payments.

Example glass-interior photography is from Unsplash and is illustrative, not a product listing. The shopkeeper photograph was provided for the website.
