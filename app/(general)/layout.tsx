import { Navbar } from '@/components';

export default function GeneralLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <>
      <Navbar />
      <div className="flex flex-col items-center p-24">{children}</div>
    </>
  );
}
