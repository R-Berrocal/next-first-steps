import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Seo contact',
  description: 'Seo contact',
  keywords: 'Seo, Next.js, React',
};

export default function Contact() {
  return (
    <main className="flex flex-col items-center p-24">
      <span className="text-6xl">Contact</span>
    </main>
  );
}
