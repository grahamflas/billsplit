import { Balances, User, UserBalance } from "../types/BaseInterfaces";

interface Props {
  balances: Balances;
  currentUser: User;
}

const BalancesData = ({ balances, currentUser }: Props) => {
  const currentUserBalance = balances.userBalances.find(
    (userBalance) => userBalance.userId === currentUser.id
  );

  const otherUserBalances = balances.userBalances.filter(
    (userBalance) => userBalance.userId !== currentUser.id
  );

  const oweOrReceive = (userBalance: UserBalance) => {
    const displayUserBalance = `${Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD",
    }).format(Math.abs(userBalance.balance))}`;

    if (userBalance.balance > 0) {
      if (userBalance.userId === currentUser.id) {
        return `owe ${displayUserBalance}`;
      }

      return `owes ${displayUserBalance}`;
    }

    if (userBalance.balance < 0) {
      if (userBalance.userId === currentUser.id) {
        return `receive ${displayUserBalance}`;
      }

      return `receives ${displayUserBalance}`;
    }

    if (userBalance.userId === currentUser.id) {
      return "are settled up";
    }

    return "is settled up";
  };

  const balanceClassNames = (userBalance: UserBalance) => {
    if (userBalance.balance > 0) {
      return "text-rose-500";
    }

    if (userBalance.balance < 0) {
      return "text-green-600";
    }

    return "text-indigo-500";
  };

  if (currentUserBalance) {
    return (
      <div className="mt-2">
        <div className={`font-bold ${balanceClassNames(currentUserBalance)}`}>
          {`You ${oweOrReceive(currentUserBalance)}`}
        </div>

        {otherUserBalances.length > 0 && (
          <div className="mx-8">
            {otherUserBalances.map((otherUserBalance) => {
              return (
                <div
                  className={`${balanceClassNames(otherUserBalance)}`}
                  key={otherUserBalance.userId}
                >
                  {`${otherUserBalance.firstName} ${
                    otherUserBalance.lastName
                  } ${oweOrReceive(otherUserBalance)}`}
                </div>
              );
            })}
          </div>
        )}
      </div>
    );
  }

  return null;
};

export default BalancesData;
