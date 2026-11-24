import './globals.css';
export const metadata = {
  metadataBase: new URL('https://najarglasshouse.com'),
  title: 'Najar Glass House Industries | Glass & Designs in Kashmir',
  description: 'Explore glass, designed glass, mirrors and more at Najar Glass House Industries in Madwan Prang Sonawari, Kashmir. Contact us for details.',
  alternates: { canonical: '/' },
  openGraph: { title: 'Najar Glass House Industries', description: 'Glass and designs for the spaces you love. Visit us in Madwan Prang Sonawari.', type: 'website' },
};
export default function RootLayout({ children }) { return <html lang="en"><body>{children}</body></html>; }
