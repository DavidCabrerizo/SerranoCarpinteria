import {defineConfig} from 'vite';
import {resolve} from 'node:path';
export default defineConfig({build:{rollupOptions:{input:{main:resolve('index.html'),legal:resolve('aviso-legal.html'),privacy:resolve('privacidad.html'),cookies:resolve('cookies.html')}}}});
