import { useState } from "react";

import { CiUser } from "react-icons/ci";

import BillSplitDropdown from "./BillSplitDropdown";
import DemoModal from "./DemoModal";
import MobileNav from "./MobileNav";
import NotificationsDropdown from "./NotificationsDropdown";

import { User } from "../types/BaseInterfaces";
import UsersRepository from "../repositories/UsersRepository";
import MyGroupsDropdown from "./MyGroupsDropdown";

interface Props {
  currentUser: User | undefined;
  demoUsers: User[] | undefined;
  editPath: string;
  hasArchivedGroups: boolean;
  logoutPath: string;
  rootPath: string;
  signInPath: string;
  signUpPath: string;
}

const TopNav = ({
  currentUser,
  demoUsers,
  editPath,
  hasArchivedGroups,
  logoutPath,
  rootPath,
  signInPath,
  signUpPath,
}: Props) => {
  const [showDemoModal, setShowDemoModal] = useState(
    !currentUser?.hasSeenDemoModal
  );

  const handleDismissDemoModal = async () => {
    setShowDemoModal(false);

    if (currentUser && !currentUser.hasSeenDemoModal) {
      UsersRepository.viewedDemoModal({ currentUser });
    }
  };

  const renderGuestActions = () => {
    if (!currentUser) {
      return (
        <>
          <a
            className="rounded-3xl px-3 py-1 text-white hover:text-indigo-200 text-indigo-500 text-center"
            href={signInPath}
          >
            <div className="flex gap-1">
              <CiUser size={25} />
              Sign in
            </div>
          </a>
          <a
            className="rounded-xl px-5 py-1 text-white bg-indigo-400 hover:bg-indigo-500 focus:bg-indigo-500 text-center"
            href={signUpPath}
          >
            Sign up
          </a>
        </>
      );
    }
  };

  const renderLoggedInActions = () => {
    if (currentUser) {
      return (
        <div className="flex flex-row items-center gap-8">
          <button
            className="rounded-xl px-5 py-1 text-white bg-indigo-400 hover:bg-indigo-500 focus:bg-indigo-500 text-center"
            onClick={() => setShowDemoModal(!showDemoModal)}
          >
            About this demo
          </button>

          <NotificationsDropdown />

          <MyGroupsDropdown />

          <BillSplitDropdown
            buttonContent={<CiUser size={25} />}
            menuItems={[
              <a
                className="group flex w-full items-center gap-2 rounded-lg px-3 py-1.5 data-focus:border-indigo-400 data-hover:border-indigo-400"
                href={editPath}
              >
                Edit profile
              </a>,
              <a
                className="group flex w-full items-center gap-2 rounded-lg px-3 py-1.5 data-focus:border-indigo-400 data-hover:border-indigo-400"
                data-turbo-method="delete"
                href={logoutPath}
              >
                Sign out
              </a>,
            ]}
            testId="user-menu"
          />
        </div>
      );
    }
  };

  return (
    <nav className="flex items-center justify-between bg-gray-800 text-white">
      <a
        className="text-indigo-300 text-3xl font-bold tracking-[0.1rem] p-1 ml-4"
        href={rootPath}
      >
        Bill÷Split
      </a>

      <MobileNav
        currentUser={currentUser}
        editPath={editPath}
        hasArchivedGroups={hasArchivedGroups}
        logoutPath={logoutPath}
        handleDemoModalButtonClick={() => setShowDemoModal(!showDemoModal)}
        rootPath={rootPath}
        signInPath={signInPath}
        signUpPath={signUpPath}
      />

      <div className="hidden sm:inline-flex mr-6 gap-4">
        {renderGuestActions()}

        {renderLoggedInActions()}
      </div>

      {currentUser && demoUsers && showDemoModal && (
        <DemoModal
          currentUser={currentUser}
          demoUsers={demoUsers}
          handleModalClose={handleDismissDemoModal}
          isOpen={showDemoModal}
        />
      )}
    </nav>
  );
};

export default TopNav;
