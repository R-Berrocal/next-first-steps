import Link from 'next/link';

export default function Home() {
  return (
    <main className="flex flex-col items-center p-24">
      <span className="text-6xl">Hola mundo</span>

      <Link href="/about">Ir a About</Link>
    </main>
  );
}
