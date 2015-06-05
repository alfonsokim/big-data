# -*- coding: utf-8 -*-

from openerp.osv import osv
from openerp.osv import fields
from openerp.tools.translate import _
import time


class escenologia_entidades(osv.osv):

	_name = 'escenologia.entidades'
	_columns = {
		'name': fields.char('Nombre de la entidad', size=200, translate=False, required=True),
		'dato_natalidad_mortandad': fields.char('Datos sobre su nacimiento y muerte', size=100, translate=False),
		'lugar_nacimiento': fields.char('Lugar de nacimiento', size=100, translate=False),
		'lugar_muerte': fields.char('Lugar de muerte', size=100, translate=False),
		'anio_nacimiento': fields.float('Anio de nacimiento', digits=(4,0) ),
		'anio_muerte': fields.float('Anio de muerte', digits=(4,0) ),
		'dato_profesion': fields.char('Datos sobre su profesion', size=200, translate=False),
		'dato_exp': fields.text('Datos sobre su experiencia'),
		'tipo_entidad': fields.selection([
            ('persona', 'Persona'),
            ('asociacion', 'Asociacion / Compania teatral'),
            ('teatro', 'Teatro / Foro'),
            ('sin_clasificar', 'Sin clasificar'),
            ], 'Tipo de entidad', select=True, help="Es el tipo de entidad (perosna fisica, persona moral, teatro, etc...)"),
		'validado': fields.boolean('Entidad validada?', help="La entidad ya fue validada,y por tanto ya se encuentra visible en el sitio web?"),
		
        'calle': fields.char('Calle'),
        'num_ext': fields.char('Numero exterior'),
        'num_int': fields.char('Numero Interior'),
        'colonia': fields.char('Colonia'),
        'ciudad': fields.char('Ciudad'),
        'estado': fields.char('Estado'),
        'codigo_postal': fields.char('Zip', size=24),
        'telefono_fijo': fields.char('Telefono fijo'),
        'telefono_celular': fields.char('Telefono celular'),
        'email': fields.char('Email'),
		'website': fields.char('Pagina de internet'),
        
		'obras_relacionadas_ids': fields.one2many('escenologia.entidades.obras.relacionadas', 'persona_id', 'Obras en las que participa la persona o asociacion'),
		'obras_albergadas_ids': fields.one2many('escenologia.entidades.obras.relacionadas', 'teatro_id', 'Obras albergadas en teatro o foro'),
		
		'category_id': fields.many2many('escenologia.entidades.categorias', 'escenologia_entidades_categorias_rel', 'partner_id', 'category_id', string='Categorias'),
	}	
	
	_defaults = {
        'validado': 0,
        'tipo_entidad': 'sin_clasificar',
    }
	
	_order = 'name'
	
	def fulltext_search__name(self, cr, uid, val, context=None):
		cad = val["string_to_search"]
		#print cad
		sql = "SELECT id, name, similarity(unaccent(lower(name)), '" + cad + "') as sim, levenshtein(unaccent(lower(name)), '" + cad + "') as lev "
		sql = sql + " FROM escenologia_entidades ORDER BY sim desc, lev asc, name asc limit 20"
		#print sql + "\n"
		cr.execute(sql)
		res = cr.fetchall()
		#sql = "SELECT id, name, levenshtein(lower(name), '" + cad + "') as lev"
		#sql = sql + " FROM escenologia_entidades ORDER BY lev asc, name asc limit 10"
		#print sql + "\n"
		#cr.execute(sql)
		#res2 = cr.fetchall()
		#res.extend(res2)
		name_separated = cad.split(" ")
		num = 1
		sql = "SELECT id, name"
		sql = sql + " FROM escenologia_entidades "
		sql = sql + " WHERE "
		for c in name_separated:
			if num > 1: 
				sql += " or "
			else:
				num += 1
			sql += " unaccent(name) ilike '%" + c + "%' "
			
		sql = sql + " ORDER BY name asc LIMIT 20"
		#print sql + "\n"
		cr.execute(sql)
		res2 = cr.fetchall()
		res.extend(res2)
		#print res
		res2 = [x[0] for x in res]
		return res2

class escenologia_entidades_categorias(osv.Model):

	_name = 'escenologia.entidades.categorias'
    
	_columns = {
        'name': fields.char('Nombre de la categoria', size=200, required=True),
        'descripcion': fields.text('Descripcion de la categoria'),
        'entidades_ids': fields.many2many('res.partner', 'escenologia_entidades_categorias_rel', 'category_id', 'partner_id', string='Entidades'),
    }
    
	_order = 'name'