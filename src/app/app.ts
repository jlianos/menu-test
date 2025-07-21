import { Component } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { Menu } from "./menu/menu";
import type { MenuItemModel } from "./menu/menuItem.model";

@Component({
	selector: "app-root",
	imports: [Menu, FormsModule],
	templateUrl: "./app.html",
})
export class App {
	filterText: string = "";

	menuData: MenuItemModel[] = [
		{
			id: "dashboard",
			text: "Dashboard",
			icon: "dashboard",
			iconColor: "text-blue-400",
			isFolder: false,
			items: [],
		},
		{
			id: "documents",
			text: "Documents",
			icon: "folder",
			iconColor: "text-yellow-400",
			isFolder: true,
			items: [
				{
					id: "reports",
					text: "Reports",
					icon: "file-text",
					iconColor: "text-emerald-400",
					isFolder: true,
					items: [
						{
							id: "annual",
							text: "Annual Reports",
							icon: "calendar",
							iconColor: "text-teal-400",
							isFolder: false,
							items: [],
						},
						{
							id: "monthly",
							text: "Monthly Reports",
							icon: "calendar-alt",
							iconColor: "text-cyan-400",
							isFolder: false,
							items: [],
						},
					],
				},
				{
					id: "invoices",
					text: "Invoices",
					icon: "file-invoice",
					iconColor: "text-rose-400",
					isFolder: true,
					items: [
						{
							id: "paid",
							text: "Paid",
							icon: "check",
							iconColor: "text-green-400",
							isFolder: false,
							items: [],
						},
						{
							id: "unpaid",
							text: "Unpaid",
							icon: "times",
							iconColor: "text-red-400",
							isFolder: false,
							items: [],
						},
					],
				},
				{
					id: "contracts",
					text: "Contracts",
					icon: "file-contract",
					iconColor: "text-purple-400",
					isFolder: false,
					items: [],
				},
			],
		},
		{
			id: "projects",
			text: "Projects",
			icon: "tasks",
			iconColor: "text-indigo-400",
			isFolder: true,
			items: [
				{
					id: "internal",
					text: "Internal",
					icon: "building",
					iconColor: "text-lime-400",
					isFolder: true,
					items: [
						{
							id: "roadmap",
							text: "Roadmap",
							icon: "road",
							iconColor: "text-amber-400",
							isFolder: false,
							items: [],
						},
						{
							id: "meeting-notes",
							text: "Meeting Notes",
							icon: "sticky-note",
							iconColor: "text-fuchsia-400",
							isFolder: false,
							items: [],
						},
					],
				},
				{
					id: "client",
					text: "Client",
					icon: "handshake",
					iconColor: "text-pink-400",
					isFolder: true,
					items: [
						{
							id: "alpha",
							text: "Alpha Corp",
							icon: "building",
							iconColor: "text-lime-400",
							isFolder: false,
							items: [],
						},
						{
							id: "beta",
							text: "Beta LLC",
							icon: "building",
							iconColor: "text-lime-300",
							isFolder: false,
							items: [],
						},
					],
				},
			],
		},
		{
			id: "settings",
			text: "Settings",
			icon: "cog",
			iconColor: "text-gray-400",
			isFolder: true,
			items: [
				{
					id: "profile",
					text: "Profile Settings",
					icon: "user-cog",
					iconColor: "text-sky-400",
					isFolder: false,
					items: [],
				},
				{
					id: "system",
					text: "System Settings",
					icon: "tools",
					iconColor: "text-stone-400",
					isFolder: false,
					items: [],
				},
			],
		},
		{
			id: "hr",
			text: "HR",
			icon: "users",
			iconColor: "text-orange-400",
			isFolder: true,
			items: [
				{
					id: "employees",
					text: "Employees",
					icon: "id-badge",
					iconColor: "text-amber-400",
					isFolder: false,
					items: [],
				},
				{
					id: "recruitment",
					text: "Recruitment",
					icon: "user-plus",
					iconColor: "text-green-400",
					isFolder: false,
					items: [],
				},
				{
					id: "leaves",
					text: "Leave Requests",
					icon: "calendar-check",
					iconColor: "text-emerald-400",
					isFolder: false,
					items: [],
				},
			],
		},
		{
			id: "support",
			text: "Support",
			icon: "life-ring",
			iconColor: "text-pink-500",
			isFolder: true,
			items: [
				{
					id: "faq",
					text: "FAQs",
					icon: "question-circle",
					iconColor: "text-indigo-400",
					isFolder: false,
					items: [],
				},
				{
					id: "tickets",
					text: "Tickets",
					icon: "ticket-alt",
					iconColor: "text-violet-400",
					isFolder: true,
					items: [
						{
							id: "open",
							text: "Open Tickets",
							icon: "folder-open",
							iconColor: "text-green-400",
							isFolder: false,
							items: [],
						},
						{
							id: "closed",
							text: "Closed Tickets",
							icon: "folder-minus",
							iconColor: "text-red-400",
							isFolder: false,
							items: [],
						},
					],
				},
			],
		},
	];
}
