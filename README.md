# Redmine Issue Field

**Redmine Issue Field** is a Redmine plugin that introduces a new custom field format: **Issue**.  
It allows you to create custom fields that reference other issues — similar to Redmine's built-in issue relations, but with more flexibility.

![image](https://github.com/user-attachments/assets/5a1f8cc1-5a45-469c-9f3c-8b3adf61c580)


## Features

- Adds a new custom field type: `Issue`
- Allows filtering selectable issues by **Tracker**
- Enables creating **multiple** issue-type custom fields on the same issue
- Selected issues are displayed as **clickable links**
- Provides a search tool to easily find and select the desired issue

## Why use it?

While Redmine already supports issue relations, this plugin enables more **controlled and customizable relationships** between issues:

- Only allow selecting issues from specific **trackers**
- Configure **multiple fields** per issue referencing other issues with different purposes
- Keep related information in custom fields rather than relying solely on Redmine’s relation types

## Compatibility

- **Redmine**: version **6.1** or higher  
- **Ruby**: version **3.3.0** or higher

## Installation

```bash
cd $REDMINE_ROOT/plugins
git clone https://github.com/CtrlMajSup/redmine_issue_field.git
```

Then **restart your application server** (e.g., Passenger, Puma, Unicorn, etc.)

## Usage

1. Go to *Administration → Custom Fields*
2. Create a new custom field of type **Issue**
3. Select the trackers from which issues can be picked
4. Assign the field to the desired issue types

## License

MIT License
