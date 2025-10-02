import { Menu, MenuButton, MenuItem, MenuItems } from "@headlessui/react";

const MyGroupsDropdown = () => {
  return (
    <Menu>
      <MenuButton data-test="my-groups-button">My Groups</MenuButton>

      <MenuItems
        transition
        anchor="bottom end"
        data-test="my-groups-dropdown"
        className="shadow-2xl flex flex-col gap-2 origin-top-right rounded-xl bg-white p-4 transition duration-100 ease-out [--anchor-gap:--spacing(1)] focus:outline-none data-closed:scale-95 data-closed:opacity-0"
      >
        <MenuItem>
          <a href="/groups">Active Groups</a>
        </MenuItem>

        <MenuItem>
          <a href="/groups/archived">Archived Groups</a>
        </MenuItem>
      </MenuItems>
    </Menu>
  );
};

export default MyGroupsDropdown;
