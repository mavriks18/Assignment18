import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { EmployeesComponent } from './employees/employees.component';
import { HomeComponent } from './home/home.component';
import { Routes, RouterModule } from '@angular/router';
import { EditEmployeesComponent } from './edit-employees/edit-employees.component';

const appRoutes:Routes = [  
  {path: 'employees', component:EmployeesComponent},
  {path: 'employees/:id', component:EditEmployeesComponent},
  {path: '', redirectTo:'employees',pathMatch:'full'}
];

@NgModule({
  declarations: [
    AppComponent,
    EmployeesComponent,
    HomeComponent,
    EditEmployeesComponent
  ],
  imports: [
    BrowserModule,
    RouterModule.forRoot(appRoutes)

  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
