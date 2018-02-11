# nuxt-cookie-storage
Cookie storage module for Nuxt.js

## Install
```bash
npm install --save nuxt-cookie-storage
```

## Usage

```js
const storage = require('nuxt-cookie-storage');

// on server side
storage.set({ foo: 'bar' }, context);
storage.set('foo', 'bar', context);
storage.get(context); // { foo: 'bar' }
storage.get('foo', context); // 'bar'

// on client side
storage.set({ foo: 'bar' });
storage.set('foo', 'bar');
storage.get(); // { foo: 'bar' }
storage.get('foo'); // 'bar'
```

## Build

```bash
npm run build
```