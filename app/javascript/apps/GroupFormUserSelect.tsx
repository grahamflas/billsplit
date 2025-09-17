// components/MultiSelectField.tsx
import { FieldProps } from "formik";
import Select from "react-select";

interface Option {
  label: string;
  value: string;
}

interface Props extends FieldProps {
  options: Option[];
  isMulti?: boolean;
}

const GroupFormUserSelect = ({
  field,
  form,
  options,
  isMulti = true,
}: Props) => {
  const onChange = (selectedOption: Option | Option[] | null) => {
    if (isMulti) {
      // For multiselect, ensure selectedOption is an array and map to values
      form.setFieldValue(
        field.name,
        (selectedOption as Option[]).map((item) => item.value)
      );
    } else {
      // For single select
      form.setFieldValue(field.name, (selectedOption as Option)?.value ?? "");
    }
  };

  const getValue = () => {
    if (options) {
      return isMulti
        ? options.filter((option) => field.value.includes(option.value))
        : options.find((option) => option.value === field.value);
    }
    return isMulti ? [] : "";
  };

  return (
    <Select
      id="group-member-select"
      name={field.name}
      value={getValue()}
      onChange={onChange}
      options={options}
      isMulti={isMulti}
      placeholder="Select options..." // Optional placeholder
    />
  );
};

export default GroupFormUserSelect;
