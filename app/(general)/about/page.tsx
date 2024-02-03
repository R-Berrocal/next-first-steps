import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'SEO Title',
  description: 'SEO Description',
  keywords: 'SEO, Next.js, React',
};

export default function About() {
  return (
    <main className="flex flex-col items-center p-24">
      <span className='text-lg'>Hola mundo</span>
      <span className="text-7xl">About</span>
    </main>
  );
}
