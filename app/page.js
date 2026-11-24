import Catalog from './store';

const business = {
  '@context': 'https://schema.org', '@type': 'Store', name: 'Najar Glass House Industries',
  url: 'https://najarglasshouse.com/', telephone: '+916005919320',
  address: { '@type': 'PostalAddress', streetAddress: 'Madwan Prang Sonawari', addressRegion: 'Kashmir' },
  openingHours: 'Mo-Sa 09:00-18:00', sameAs: ['https://www.instagram.com/najarglass/'],
};
export default function Page() { return <><script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(business) }} /><Catalog /></>; }
