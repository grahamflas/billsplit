import { useEffect } from "react";

import { Field, useFormikContext } from "formik";

import { Group } from "../types/BaseInterfaces";
import { NewExpenseFormValues } from "./NewExpenseForm";

interface Props {
  fieldClasses: string;
  groups: Group[];
  id: string;
}

const NewExpenseFormUserSelect = ({ fieldClasses, groups, id }: Props) => {
  const {
    values: { groupId },
    setFieldValue,
  } = useFormikContext<NewExpenseFormValues>();

  const selectedGroup = groups.find((group) => group.id == groupId);

  const selectedGroupHasUsers =
    selectedGroup?.users && selectedGroup.users.length > 0;

  useEffect(() => {
    if (selectedGroupHasUsers) {
      setFieldValue("userId", selectedGroup.users[0].id);
    }
  }, [groupId]);

  if (selectedGroupHasUsers) {
    return (
      <Field className={fieldClasses} as="select" name="userId" id="userId">
        {selectedGroup.users.map((user) => (
          <option value={user.id} key={user.id}>
            {`${user.firstName} ${user.lastName}`}
          </option>
        ))}
      </Field>
    );
  }

  return (
    <Field className={fieldClasses} as="select" name="userId">
      <option value="">Select a user</option>
    </Field>
  );
};

export default NewExpenseFormUserSelect;
