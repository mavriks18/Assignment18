import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {AppComponent} from './app.component';
import { EmployeesComponent } from './employees/employees.component';
import { from } from 'rxjs';
import { BrowserDynamicTestingModule } from '@angular/platform-browser-dynamic/testing';
import { BrowserModule } from '@angular/platform-browser';

const routes: Routes = [];

@NgModule({
  declarations : [EmployeesComponent],
  imports: [BrowserModule, RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
