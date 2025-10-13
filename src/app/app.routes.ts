// app.routes.ts
import type { Routes } from '@angular/router';
import { Transactions } from './transactions/transactions';

// Features (adjust import paths)

export const routes: Routes = [
  { path: 'dashboard', component: Transactions },
  { path: 'all-transactions', component: Transactions },
  { path: '', pathMatch: 'full', redirectTo: 'dashboard' },
  { path: '**', redirectTo: 'dashboard' },
];
