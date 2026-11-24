export default function robots() { return { rules: { userAgent: '*', allow: '/', disallow: ['/admin', '/auth/'] }, sitemap: 'https://najarglasshouse.com/sitemap.xml' }; }
