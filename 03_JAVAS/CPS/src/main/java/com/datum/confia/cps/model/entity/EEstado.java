package com.datum.confia.cps.model.entity;

/**
 * 
 * @author dflores
 * undefined se coloca este estado porque cuando se realiza la referecia por numero esta inicia con 0 por locual fue necesariop correr un numero 
 * y para solventar se agrega el estado undefined este no deveria usar segun catalo de estados tabla estados.
 */
public enum EEstado {
	UNDEFINED,
	INGRESADO,
	PENDIENTE,
	ACTUALIADO,
	FALLADO,
	ANULADO
}
