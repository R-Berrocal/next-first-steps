import { Metadata } from 'next';
import React from 'react';

export const metadata: Metadata = {
  title: 'Seo pricing',
  description: 'Seo pricing',
  keywords: 'Seo, Next.js, React',
};

export default function Pricing() {
  return (
    <main className="flex flex-col items-center p-24">
      <span className="text-6xl">Pricing</span>
    </main>
  );
}
