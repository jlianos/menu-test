import { Component, inject, signal } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { Router, RouterOutlet } from "@angular/router";
import { FontAwesomeModule } from "@fortawesome/angular-fontawesome";
import { faBars } from "@fortawesome/free-solid-svg-icons";
import { Menu } from "./menu/menu";
import type { MenuItemModel } from "./menu/menuItem.model";
import { menuData } from "./menuData";

@Component({
	selector: "app-root",
	imports: [Menu, FormsModule, FontAwesomeModule, RouterOutlet],
	templateUrl: "./app.html",
})
export class App {
	private router = inject(Router);

	readonly isMenuOpen = signal(true);
	readonly mainHeaderText = "Ioannis Lianos";
	readonly subHeaderText = "Developer";

	bars = faBars;
	menuData = menuData;

	toggleMenu(v: boolean) {
		this.isMenuOpen.set(v);
	}

	menuItemClicked(menuItem: MenuItemModel) {
		this.router.navigateByUrl(menuItem.id);
		this.toggleMenu(false);
	}
}
