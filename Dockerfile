FROM node:18-alpine AS base

# Instalar dependencias solo cuando sea necesario
FROM base AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Instalar dependencias basadas en el administrador de paquetes preferido
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi


# Reconstruir el código fuente sólo cuando sea necesario
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Next.js recopila datos de telemetría completamente anónimos sobre el uso general.
# Aprende mas aqui: https://nextjs.org/telemetry
# Descomente la siguiente línea en caso de que desee deshabilitar la telemetría durante la compilación.
# ENV NEXT_TELEMETRY_DISABLED 1

RUN \
  if [ -f yarn.lock ]; then yarn run build; \
  elif [ -f package-lock.json ]; then npm run build; \
  elif [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm run build; \
  else echo "Lockfile not found." && exit 1; \
  fi

# Imagen de producción, copie todos los archivos y ejecútelo a continuación.
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production
# Descomente la siguiente línea en caso de que desee deshabilitar la telemetría durante el tiempo de ejecución.
# ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public

# Establecer el permiso correcto para la caché previa al renderizado
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Aproveche automáticamente los seguimientos de salida para reducir el tamaño de la imagen
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000
# establecer el nombre de host en localhost
ENV HOSTNAME "0.0.0.0"

# server.js se crea en la siguiente compilación desde la salida independiente
# https://nextjs.org/docs/pages/api-reference/next-config-js/output
CMD ["node", "server.js"]