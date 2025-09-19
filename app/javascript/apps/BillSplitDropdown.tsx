import { JSX } from "react";

import { Menu, MenuButton, MenuItem, MenuItems } from "@headlessui/react";

interface Props {
  buttonContent: JSX.Element;
  menuItems: JSX.Element[];
  testId: string;
}

const BillSplitDropdown = ({ buttonContent, menuItems, testId }: Props) => {
  return (
    <Menu>
      <MenuButton data-test={`${testId}-button`}>{buttonContent}</MenuButton>

      <MenuItems
        transition
        anchor="bottom end"
        data-test={`${testId}-dropdown`}
        className="shadow-2xl w-40 origin-top-right rounded-xl bg-white p-1 transition duration-100 ease-out [--anchor-gap:--spacing(1)] focus:outline-none data-closed:scale-95 data-closed:opacity-0"
      >
        {menuItems.map((menuItem) => {
          return <MenuItem>{menuItem}</MenuItem>;
        })}
      </MenuItems>
    </Menu>
  );
};

export default BillSplitDropdown;
