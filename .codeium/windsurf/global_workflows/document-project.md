---
description: Document or update project design and technical architecture
auto_execution_mode: 1
---

# Project Documentation Workflow

This workflow helps you create and maintain two critical living documents for the project:
1. **Project Design Document** - High-level features, business logic, and decisions
2. **Technical Architecture Document** - Detailed codebase structure for AI navigation

## Steps

### 1. Analyze the Codebase Structure

First, explore the project to understand its structure:
- Identify main directories and their purposes
- Find configuration files (package.json, requirements.txt, Cargo.toml, go.mod, etc.)
- Locate entry points (main files, server files, CLI files)
- Identify key frameworks and technologies used

### 2. Gather Project Context

Read existing documentation:
- README.md/AGENTS.md files
- Existing documentation folders
- Code comments and docstrings
- Configuration files for build systems, dependencies, deployment

### 3. Create or Update Project Design Document

Create/update `PROJECT_DESIGN.md` in the project root with:

**Structure:**
```markdown
# Project Design Document

## Overview
[Brief project description - what it does, who it's for]

## Core Features
[List key features with brief explanations]

## Business Logic & Key Concepts
[Main domain concepts, workflows, business rules]

## Architectural Decisions
[Major decisions made and why - e.g., why this framework, why this pattern]

## User Workflows
[How users interact with the system - main use cases]

## Future Considerations
[Planned features, known limitations, areas for improvement]
```

**Guidelines:**
- Keep it high-level and focused on "what" and "why"
- Explain business decisions and feature rationale
- Avoid implementation details
- Use clear, non-technical language where possible
- Maximum 2-3 pages

### 4. Create or Update Technical Architecture Document

Create/update `TECHNICAL_ARCHITECTURE.md` in the project root with:

**Structure:**
```markdown
# Technical Architecture Document

## Technology Stack
[Languages, frameworks, libraries, tools]

## Project Structure
[Directory layout with purpose of each major folder]

## Key Components
[Main modules/packages and their responsibilities]

## Data Models
[Core data structures, schemas, database tables if applicable]

## API & Interfaces
[Public APIs, internal interfaces, communication patterns]

## Code Organization Patterns
[How code is organized - MVC, layered, modular, etc.]

## Entry Points & Flow
[Where execution starts, how requests flow through the system]

## Configuration & Environment
[How the system is configured, environment variables, config files]

## Testing Strategy
[Where tests are, how to run them, what's tested]

## Build & Deployment
[How to build, run, and deploy the project]

## Important Files to Know
[Critical files an AI should check when making changes]
```

**Guidelines:**
- Focus on "where" and "how" for navigation
- Be specific about file paths and module names
- Include code organization patterns
- Mention dependencies between components
- Use backticks for file/directory names
- Maximum 3-4 pages

### 5. Validate the Documents

Review both documents to ensure:
- They complement each other (design = why/what, architecture = where/how)
- They're concise but informative
- File paths and names are accurate
- They provide clear entry points for AI agents
- They can be quickly scanned (use bullet points, headers)

### 6. Update Commit

After creating or updating the documents:
- Review the changes
- Commit with a clear message like "docs: update project documentation"

## When to Run This Workflow

Run this workflow when:
- Starting a new project (initial documentation)
- After major architectural changes
- After adding significant new features
- Periodically (e.g., monthly) to keep docs fresh
- When onboarding new team members or AI agents

## Tips for AI Agents

- Read both documents before making significant changes
- Update documents when you make architectural changes
- Keep documents concise - quality over quantity
- Focus on information that helps navigate and understand the codebase
- These are living documents - update them regularly