'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import React from 'react';

import style from './ActiveLink.module.css';

interface Props {
  path: string;
  text: string;
}

export const ActiveLink = ({ path, text }: Props) => {
  const pahtName = usePathname();
  return (
    <Link
      className={`${style.link} ${pahtName === path && style['active-link']}`}
      href={path}
    >
      {text}
    </Link>
  );
};
