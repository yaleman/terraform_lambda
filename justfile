default:
    just --list

# update the documentation for the module
update_docs:
    terraform-docs markdown table . --output-file README.md
