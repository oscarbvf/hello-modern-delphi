# HelloModernDelphi

## Overview

**HelloModernDelphi** is a small exploratory project focused on **modern Delphi language features** introduced in versions after classic Delphi (Delphi 5 era).

The application consists of a simple VCL form with buttons that trigger isolated examples. Each example demonstrates a specific language construct or runtime feature commonly used in contemporary Delphi codebases.

This project is intended as a **learning and reference project**, not as a production application.

---

## Purpose

The main goals of this repository are:

- To revisit Delphi from a modern perspective
- To demonstrate practical usage of key language and RTL features
- To serve as a compact technical showcase for evaluation and study

---

## Demonstrated Concepts

The project includes simple, self-contained examples of the following concepts:

### Collections

- `TList<T>`
- `TDictionary<TKey, TValue>`

Used to demonstrate generic collections and type-safe container usage.

---

### Anonymous Methods (Lambda Functions)

- Inline anonymous procedures/functions
- Passing behavior as parameters
- Functional-style patterns supported by modern Delphi

---

### Custom Attributes

- Definition of `TCustomAttribute` descendants
- Decorating classes and methods with metadata
- Preparing metadata for runtime inspection

---

### RTTI (Run-Time Type Information)

- Using RTTI to inspect types and attributes at runtime
- Extracting metadata from custom attributes
- Generating simple logs based on RTTI inspection

---

### Nullable Types

- Usage of `TNullable<T>`
- Safe handling
- Avoiding sentinel values and excessive conditionals

---

## Project Structure (Simplified)
HelloModernDelphi/
├── HelloModernDelphi.dpr
├── HelloModernDelphi.dproj
├── MainForm.pas
├── MainForm.dfm
├── GenericLogger.pas
├── NullableUtils.pas
├── uGenericsUtils.pas
├── uLogDemo.pas
└── README.md


Each unit focuses on a small, well-defined concept.

---

## Requirements

- Windows
- Embarcadero Delphi (RAD Studio) — modern version (10.x or newer recommended)
- VCL framework

No external dependencies are required.

---

## How to Run

1. Open `HelloModernDelphi.dproj` in Delphi
2. Build and run the project
3. Use the buttons on the main form to execute each example

Output is displayed via simple UI feedback and/or logging mechanisms, depending on the example.

---

## Scope and Limitations

- This project is **not** intended to demonstrate UI design or UX patterns
- Error handling is intentionally minimal
- Examples are deliberately simple to keep the focus on language features

---

## Related Projects

This repository is part of a larger Delphi learning portfolio:

- **ClientVCL** – Desktop client application
- **ServerHorse** – REST backend using Horse framework

These projects are maintained as separate repositories and linked via a portfolio aggregator.

---

## License

This project is provided for educational and demonstration purposes.
