import { Component, input, output } from "@angular/core";
import { MenuItem } from "./menu-item/menu-item";
import type { MenuItemModel } from "./menuItem.model";

@Component({
	selector: "app-menu",
	imports: [MenuItem],
	templateUrl: "./menu.html",
	host: {
		class: "min-h-0"
	}
})
export class Menu {
	menuData = input<MenuItemModel[]>([]);
	filter = input<string>("");

	onItemClicked = output<MenuItemModel>();

	itemClicked(menuItem: MenuItemModel) {
		console.dir(menuItem);
	}

	menuDataFiltered(menuData: MenuItemModel[], filter: string) {
		const filterToLowerCase = filter.toLowerCase();

		return menuData.reduce((result: MenuItemModel[], currMenuItem: MenuItemModel) => {
			const filteredKids = currMenuItem.items ? this.menuDataFiltered(currMenuItem.items, filter) : [];

			const itemIncludesFilter = (item: MenuItemModel): boolean => {
				return (
					filterToLowerCase === "" ||
					(!item.isFolder && item.text.toLowerCase().includes(filterToLowerCase)) ||
					(item.isFolder && item.items.some((item) => itemIncludesFilter(item))) ||
					false
				);
			};

			const matches = itemIncludesFilter(currMenuItem);

			if (matches || filteredKids.length) {
				result.push({
					...currMenuItem,
					...(currMenuItem.isFolder ? { items: filteredKids } : {}),
				});
			}

			return result;
		}, [] as MenuItemModel[]);
	}
}
