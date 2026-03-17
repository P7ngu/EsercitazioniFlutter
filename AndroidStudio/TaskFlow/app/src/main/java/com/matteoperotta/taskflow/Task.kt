package com.matteoperotta.taskflow

import java.util.UUID

// Priority -enum class per la priorita del task
// in kotlin le classi sono enum con prioprita.
//Label e la stringa mostrata nella UI, e color il colore ARGB che verra impostato

enum class Priority (var label: String, val color: Long) {
    LOW("Bassa", 0xFF4c4f50L),
    MEDIUM("Media", 0xFFFFC107L),
    HIGH ("Alta", 0xFFF44336L)
}


// Domani model, la data class Task immutabile per design, genera equals hashcode e copy did efault
data class Task (
    val id: String = UUID.randomUUID().toString(),
    val title: String,
    val description: String = "",
    val priority: Priority = Priority.LOW,
    val isCompleted: Boolean = false
    ) {
    //proprieta calcolata, non salvata e deriva da iscompleted
    val isDone: Boolean get() = isCompleted
}