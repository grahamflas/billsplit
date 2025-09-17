import { mountGroupDetails } from "./GroupDetails";
import { mountGroupForm } from "./GroupForm";
import { mountGroupsListContainer } from "./GroupsListContainer";
import { mountNewExpenseForm } from "./NewExpenseForm";
import { mountToaster } from "./Toaster";
import { mountTopNav } from "./TopNav";
import "./tailwind.css";

document.addEventListener("turbo:load", () => {
  if (document.getElementById("GroupDetails")) {
    mountGroupDetails();
  }

  if (document.getElementById("GroupForm")) {
    mountGroupForm();
  }

  if (document.getElementById("GroupsListContainer")) {
    mountGroupsListContainer();
  }

  if (document.getElementById("NewExpenseForm")) {
    mountNewExpenseForm();
  }

  if (document.getElementById("Toaster")) {
    mountToaster();
  }

  if (document.getElementById("TopNav")) {
    mountTopNav();
  }
});
